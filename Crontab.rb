# encoding: utf-8

class Crontab
  
  def get_jobs
    string = `crontab -l`
    string.strip.split("\r\n")
  end
  
  def save_jobs(jobs)
    string = jobs.join("\r\n")
    `echo "#{string}" | crontab -`
  end
  
  def exists?(job)
    jobs = get_jobs
    jobs.include?(job)
  end
  
  def add_job(job)
    if exists?(job)
      false
    else
      jobs = get_jobs
      jobs << job
      save_jobs(jobs)
      true
    end
  end
  
  def remove_job(job)
    if exists?(job)
      jobs = get_jobs
      jobs.delete(job)
      save_jobs(jobs)
    else
      false
    end
  end
  
end
