# MUTEX critical section within file write lock. One file - one mutex.
class CriticalSection
  def initialize file
    @file_str=file.to_s
  end

  def lock
    @file=File.open "#{Dir.tmpdir}/ptf.#{@file_str}.lock", 'w'
    @file.flock File::LOCK_EX
  end

  def unlock
    @file.flock File::LOCK_UN
  end

  def self.synchronize file
    cs=CriticalSection.new(file)
    cs.lock
    yield
    cs.unlock
  end
end

