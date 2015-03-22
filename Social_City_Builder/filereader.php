<?php
function find_files($path, $pattern, $callback)
{
    $path = rtrim(str_replace("\\", "/", $path), '/') . '/*';
    foreach (glob($path) as $fullname)
    {
        if (is_dir($fullname))
        {
            find_files($fullname, $pattern, $callback);
        }
        else if (preg_match($pattern, $fullname))
        {
          	$fullname = str_replace('bin/','',$fullname);
            call_user_func($callback, $fullname);
        }
    }
}
function my_handler($filename) {
  echo "'".$filename."',"."\n";
}
find_files('bin/assets', '/png$/', 'my_handler');
?> 