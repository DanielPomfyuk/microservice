class DataBaseError < StandardError
  def initialize(message, status)
    @status = status
    msg = "Some problem with database. Status is #{@status} . #{message}"
    super(msg)
  end
  def return_json
    {:message => self.message,:status => @status}.to_json
  end
end