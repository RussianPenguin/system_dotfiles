import Data.List -- списки

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.InsertPosition as H
import XMonad.Hooks.ManageHelpers -- набор хелперов для более удобной работы

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad

import qualified XMonad.StackSet as W

import XMonad.Layout.NoBorders
import XMonad.Layout.Named
import XMonad.Layout.TrackFloating
import XMonad.Layout.ResizableTile
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.StackTile
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM

import XMonad.Actions.Warp
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleRecentWS -- (17) cycle between workspaces
                                    --      in most-recently-used order

import qualified Data.Map as M

import System.IO

customTerminal = "urxvt"

-- The command to take a selective screenshot, where you select
-- -- what you'd like to capture on the screen.
cmdSelectScreenshot = "$HOME/bin/select-screenshot"
--
-- -- The command to take a fullscreen screenshot.
cmdScreenshot = "$HOME/bin/screenshot"

main = do
	xmproc <- spawnPipe "xmobar -x 2" 
	xmonad $ ewmh defaultConfig
		{ modMask = mod4Mask -- Use Super instead of Alt
		, focusedBorderColor = customFocusedBorderColor
		, terminal = customTerminal
		, borderWidth = 1
		, handleEventHook = do
				ewmhDesktopsEventHook
				docksEventHook
				fullscreenEventHook -- Full screen setup
		, startupHook = customStartupHook
		, layoutHook = customLayoutHooks
		-- setup three independent workspaces
		-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-IndependentScreens.html
		--, workspaces = withScreens 3 ["web", "ide"] -- ++ map show [3..9 :: Int] 
		--, workspaces = ["web", "email", "irc"]
		, workspaces = ["web", "ide", "debug", "admin", "vm", "irc", "video"] ++ ["8", "9"]
		, manageHook = manageSpawn <+> customManageHooks <+> manageHook defaultConfig 
		, logHook = dynamicLogWithPP xmobarPP
			{ ppOutput = hPutStrLn xmproc
			, ppLayout = const ""
			, ppTitle = xmobarColor "green" "" . shorten 150
			}
			-- move pointer when switch focused window (warp to nearest point of focused window)
			-- >> updatePointer (Relative 0.1 0.9)
			-- >> ewmhDesktopsLogHook
		, keys = \c -> keyBindings c `M.union` keys defaultConfig c
		}
		where
			keyBindings conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
				[ ((modMask, xK_z), warpToWindow (0.5) (0.5)) -- @@ Move pointer to currently focused window
				-- work with wolume control
				, ((0, 0x1008FF11), spawn "amixer -D pulse sset Master 2%-" >> return ())
				, ((0, 0x1008FF13), spawn "amixer -D pulse sset Master 2%+" >> return ())
				, ((0, 0x1008FF12), spawn "amixer -D pulse sset Master toggle" >> return())
				-- screenshot tool
				, ((0, xK_Print), spawn cmdScreenshot)
				, ((shiftMask, xK_Print), spawn cmdSelectScreenshot)
				-- office tools
				-- calculator
				, ((0, 0x1008ff1d), spawn (customTerminal ++ " -e /bin/sh -c 'bc -l'") >> return ())
				, ((modMask, xK_c), namedScratchpadAction customNamedScratchPads "terminal")
				, ((modMask, xK_k), namedScratchpadAction customNamedScratchPads "keepass")
				]
				++
				-- https://wiki.haskell.org/Xmonad/Config_archive/Brent_Yorgey's_darcs_xmonad.hs
				-- cycle workspaces in most-recently-used order
				-- see definition of custom cycleRecentWS' below, and also (17)
				--[("M-S-<Tab>", cycleRecentWS' [xK_Super_L, xK_Shift_L] xK_Tab xK_grave)]
				-- ++
				-- mod-[1..9] %! Switch to workspace N
				-- mod-shift-[1..9] %! Move client to workspace N
				[((m .|. modMask, k), windows $ f i)
					| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
					, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
				++
				--
				-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
				-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
				--
				[((m .|. modMask, key), do 
							warpToScreen sc 0.5 0.5
							screenWorkspace sc >>= flip whenJust (windows . f))
					| (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
					, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
			customFocusedBorderColor = "#33CCFF"


customLayoutHooks = 
	onWorkspaces ["ide", "video"] fullLayout $
	trackFloating 
	$ toggle 
	$ tallLayout ||| stackLayout ||| fullLayout
	where
		basicVertical = smartBorders $ Tall 1 (3/100) (2/3)
		basicHorizontal = smartBorders $ StackTile 1 (3/100) (2/3)
		tallLayout = named "Tall" $ avoidStruts $ basicVertical
		stackLayout = named "MirrorTall" $ avoidStruts $ Mirror $ basicVertical
		fullLayout = named "Full" $ noBorders Full
		toggle = toggleLayouts fullLayout

customManageHooks = 
	manageDocks
	<+> composeAll
		[ className =? "Plugin-container" --> doFloat
		, className =? "Firefox" --> doShift "web"
		, className =? "vlc" --> doShift "video"
		, (className =? "Firefox" <&&> resource /? "Navigator") --> doFloat
		, className =? "jetbrains-phpstorm" --> doShift "ide"
		-- Saleae Logic software fix
		, className =? "Logic" --> doIgnore
		-- splash screen for RepetierHost
		, title =? "SplashScreen" --> doCenterFloat
		, title =? "Менеждер слайсинга" --> doCenterFloat
		, title =? "Slic3r" --> doCenterFloat
		-- games
		, className =? "explorer.exe" --> doCenterFloat
		, className =? "Gothic.exe" --> doShift "admin"
		, isDialog --> doF W.shiftMaster <+> doFloat
		, isFullscreen --> doFullFloat
		]
	<+> namedScratchpadManageHook customNamedScratchPads

-- modified variant of cycleRecentWS from XMonad.Actions.CycleRecentWS (17)
-- which does not include visible but non-focused workspaces in the cycle
cycleRecentWS' = cycleWindowSets options
	where 
		options w = map (W.view `flip` w) (recentTags w)
		recentTags w = map W.tag $ W.hidden w ++ [W.workspace (W.current w)]

-- отрицание для сравнения чего-то с чем-то в managehooks
(/?) :: Eq a => Query a -> a -> Query Bool
qa /? a = qa =? a >>= return . not

endsWith :: Eq a => Query [a] -> [a] -> Query Bool
qa `endsWith` a = qa >>= return . (isSuffixOf a)

-- scratchpad helpers (boolean function for create named scratchpad)

isKeePass :: Query Bool
isKeePass = (className =? "KeePass2")

isScratchPad :: Query Bool
isScratchPad = (resource =? "scratchpad")

-- scratchpad configuration 
customNamedScratchPads :: NamedScratchpads
customNamedScratchPads = 
	[
		NS "terminal" term isScratchPad quakeWindow,
		NS "keepass" keepass isKeePass windowRectFloat
	]
	where
		keepass = "/usr/bin/keepass"
		term = customTerminal ++ " -name scratchpad"
		quakeWindow = customFloating $ W.RationalRect (0) (0) (1) (0.2)
		windowRectFloat = customFloating $ W.RationalRect (1/10) (1/10) (4/5) (4/5)

customStartupHook :: X()
customStartupHook = do
	-- see https://github.com/xmonad/xmonad/issues/42
	spawn "xprop -root -remove _NET_WORKAREA"
