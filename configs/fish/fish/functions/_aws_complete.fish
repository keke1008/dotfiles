# https://github.com/aws/aws-cli/issues/1079#issuecomment-541997810

function _aws_complete
    set -lx COMP_SHELL fish
    set -lx COMP_LINE (commandline)

    aws_completer
end
