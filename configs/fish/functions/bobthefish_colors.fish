function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'
    # Color palette
    # See https://github.com/folke/tokyonight.nvim/blob/main/extras/alacritty/tokyonight_night.yml
    set -l black     15161e
    set -l red       f7546c
    set -l green     9ece6a
    set -l yellow    e0af68
    set -l blue      7aa2f7
    set -l magenta   bb9af7
    set -l cyan      7dcfff
    set -l white     a9b1d6

    set -l brblack   414868
    set -l brred     f7768e
    set -l brgreen   9ece6a
    set -l bryellow  e0af68
    set -l brblue    7aa2f7
    set -l brmagenta bb9af7
    set -l brcyan    7dcfff
    set -l brwhite   c0caf5

    set -l primary_bg 3b4261

    set -x color_initial_segment_exit    $black      $red     --bold
    set -x color_initial_segment_private $black      $yellow  --bold
    set -x color_initial_segment_su      $black      $magenta --bold
    set -x color_initial_segment_jobs    $black      $green   --bold

    set -x color_path                    $primary_bg $blue
    set -x color_path_basename           $primary_bg $blue    --bold
    set -x color_path_nowrite            $red        $black
    set -x color_path_nowrite_basename   $red        $black   --bold

    set -x color_repo                    $black      $blue
    set -x color_repo_work_tree          $black      $blue
    set -x color_repo_dirty              $blue       $black   --bold
    set -x color_repo_staged             $cyan       $black

    set -x color_vi_mode_default         $brblue     $black   --bold
    set -x color_vi_mode_insert          $brgreen    $black   --bold
    set -x color_vi_mode_visual          $brmagenta  $black   --bold

    set -x color_vagrant                 $brcyan     $black
    set -x color_k8s                     $magenta    $white   --bold
    set -x color_username                $blue       $black   --bold
    set -x color_hostname                $blue       $black
    set -x color_rvm                     $brmagenta  $black   --bold
    set -x color_virtualfish             $cyan       $black   --bold
    set -x color_virtualgo               $brblue     $black   --bold
    set -x color_desk                    $brblue     $black   --bold
end
