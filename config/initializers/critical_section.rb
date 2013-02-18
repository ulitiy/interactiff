# MUTEX critical section within file write lock. One file - one mutex.
class CriticalSection
  TIMEOUT = 1
  def initialize file
    @file_str=file.to_s
  end

  def get_file
    @file||=File.open "#{Dir.tmpdir}/interactiff.#{@file_str}.lock", 'w'
  end

  def lock
    get_file
    @file.flock File::LOCK_EX
    self
  end

  def lock?
    get_file
    if @file.flock File::LOCK_EX | File::LOCK_NB
      unlock
      return false
    end
    true
  end

  def unlock
    @file.flock File::LOCK_UN
    self
  end

  def self.synchronize file, l=true
    if l
      cs=CriticalSection.new(file)
      cs.lock
    end
    Timeout.timeout TIMEOUT do
      yield
    end
  #TODO: log exceptions
  ensure
    cs.unlock if l
  end
end
