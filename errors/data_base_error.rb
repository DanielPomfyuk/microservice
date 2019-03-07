class DataBaseError < StandardError
  attr_accessor :status
  def initialize(message, status)
    self.status = status
    msg = "Some problem with database. Status is #{@status} . #{message}"
    super(msg)
  end
  def return_json
    {:message => self.message,:status => @status}.to_json
  end
end