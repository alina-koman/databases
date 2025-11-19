from app.my_project.kindergarten.service.child_service import ChildService

service = ChildService()

class ChildController:
    def get_all(self):
        return service.get_all_children()
    
    def get_one(self, child_id):
        return service.get_child(child_id)

    def create(self, data):
        return service.create_child(data)

    def update(self, child_id, data):
        return service.update_child(child_id, data)
    
    def patch(self, child_id, data):
        return service.patch_child(child_id, data)

    def delete(self, child_id):
        return service.delete_child(child_id)

    def get_parents(self, child_id):
        return service.get_parents(child_id)
    
    def get_k_children(self, name):
        return service.get_children_by_kindergarten(name)