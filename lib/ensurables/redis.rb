module Ensurable
  class Redis
    def running?
      # this is probly pretty dumb, it greps the proc list for redis-server
      # taking into account that the grep counts as one
      num = `ps aux | grep redis-server | wc -l`.to_i
      true if num > 1
    end
  end
end
