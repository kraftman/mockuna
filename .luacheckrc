std = 'max'
globals = {
    'ngx',
    'assert',
    'describe',
    'it',
    'std',
    'globals',
}

files["test/*"] = {
    std = "+busted",
    max_line_length = 80
}
exclude_files = {'.luacheckrc'}
self = false