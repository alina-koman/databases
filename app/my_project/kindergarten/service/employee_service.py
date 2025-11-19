from app.my_project.kindergarten.dao.employee_dao import EmployeeDAO

class EmployeeService:
    def __init__(self):
        self.dao = EmployeeDAO()

    def get_all(self):
        return self.dao.get_all()
    
    def get_by_id(self, employee_id):
        return self.dao.get_by_id(employee_id)

    def create(self, data):
        return self.dao.create(data)

    def update(self, employee_id, data):
        return self.dao.update(employee_id, data)
    
    def patch(self, employee_id, data):
        return self.dao.patch(employee_id, data)

    def delete(self, employee_id):
        return self.dao.delete(employee_id)