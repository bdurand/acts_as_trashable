module ActsAsTrashable
  
  def self.included (base)
    base.extend(ActsMethods)
  end
  
  module ActsMethods
    # Class method that injects the trash behavior into the class.
    def acts_as_trashable
      extend ClassMethods
      include InstanceMethods
      alias_method_chain :destroy, :trash
    end
  end
  
  module ClassMethods
    # Empty the trash for this class of all entries older than the specified maximum age in seconds.
    def empty_trash (max_age)
      TrashRecord.empty_trash(max_age, :only => self)
    end
    
    # Restore a particular entry by id from the trash into an object in memory. The record will not be saved.
    def restore_trash (id)
      trash = TrashRecord.find_trash(self, id)
      return trash.restore if trash
    end
    
    # Restore a particular entry by id from the trash, save it, and delete the trash entry.
    def restore_trash! (id)
      trash = TrashRecord.find_trash(self, id)
      return trash.restore! if trash
    end
  end
  
  module InstanceMethods
    def destroy_with_trash
      TrashRecord.transaction do
        trash = TrashRecord.new(self)
        trash.save!
        destroy_without_trash
      end
    end
  end
  
end
