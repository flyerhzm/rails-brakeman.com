module Support
  module DelayedJobHelper
    def work_off
      Delayed::Job.all.each do |job|
        job.payload_object.perform
        job.destroy
      end
    end
  end
end
