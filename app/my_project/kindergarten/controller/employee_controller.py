from app.my_project.kindergarten.service.employee_service import EmployeeService

service = EmployeeService()

class EmployeeController:
    def get_all(self):
        return service.get_all()
    
    def get_one(self, employee_id):
        return service.get_by_id(employee_id)

    def create(self, data):
        return service.create(data)

    def update(self, employee_id, data):
        return service.update(employee_id, data)
    
    def patch(self, employee_id, data):
        return service.patch(employee_id, data)

    def delete(self, employee_id):
        return service.delete(employee_id)