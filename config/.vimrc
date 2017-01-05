set tabstop=4

let g:airline_powerline_fonts = 1

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2
set t_Co=256
