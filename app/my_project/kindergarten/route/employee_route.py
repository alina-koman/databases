from flask import Blueprint, jsonify, request, Response
from app.my_project.kindergarten.controller.employee_controller import EmployeeController

employee_bp = Blueprint('employee_bp', __name__)
controller = EmployeeController()

@employee_bp.route('/employees', methods=['GET'])
def get_all():
    return jsonify(controller.get_all())

@employee_bp.route('/employees', methods=['POST'])
def create():
    data = request.json
    new_id = controller.create(data)
    return jsonify({"message": "Employee created", "id": new_id}), 201

@employee_bp.route('/employees', methods=['HEAD'])
def head():
    return jsonify(controller.get_all())

@employee_bp.route('/employees', methods=['OPTIONS'])
def options():
    response = Response()
    response.headers['Allow'] = 'GET, POST, HEAD, OPTIONS'
    return response

@employee_bp.route('/employees/<int:employee_id>', methods=['GET'])
def get_one(employee_id):
    employee = controller.get_one(employee_id)
    if employee:
        return jsonify(employee)
    return jsonify({"error": "Employee not found"}), 404

@employee_bp.route('/employees/<int:employee_id>', methods=['PUT'])
def update(employee_id):
    data = request.json
    controller.update(employee_id, data)
    return jsonify({"message": "Employee updated"})

@employee_bp.route('/employees/<int:employee_id>', methods=['PATCH'])
def patch(employee_id):
    data = request.json
    controller.patch(employee_id, data)
    return jsonify({"message": "Employee patched"})

@employee_bp.route('/employees/<int:employee_id>', methods=['DELETE'])
def delete(employee_id):
    controller.delete(employee_id)
    return jsonify({"message": "Employee deleted"})