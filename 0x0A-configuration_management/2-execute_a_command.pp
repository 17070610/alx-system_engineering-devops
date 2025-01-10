# Kill a process killmenow

exec {
  command  => 'pkill killmenow',
  provider => 'shell',
}
