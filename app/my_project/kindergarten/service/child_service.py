from app.my_project.kindergarten.dao.child_dao import ChildDAO

class ChildService:
    def __init__(self):
        self.dao = ChildDAO()

    def get_all_children(self):
        return self.dao.get_all()
    
    def get_child(self, child_id):
        return self.dao.get_by_id(child_id)

    def create_child(self, data):
        return self.dao.create(data)

    def update_child(self, child_id, data):
        return self.dao.update(child_id, data)
    
    def patch_child(self, child_id, data):
        return self.dao.patch(child_id, data)

    def delete_child(self, child_id):
        return self.dao.delete(child_id)

    def get_parents(self, child_id):
        return self.dao.get_parents_by_child(child_id)
    
    def get_children_by_kindergarten(self, k_name):
        return self.dao.get_children_in_kindergarten(k_name)