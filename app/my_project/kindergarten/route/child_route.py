from flask import Blueprint, jsonify, request, Response
from app.my_project.kindergarten.controller.child_controller import ChildController

child_bp = Blueprint('child_bp', __name__)
controller = ChildController()

@child_bp.route('/children', methods=['GET'])
def get_children():
    return jsonify(controller.get_all())

@child_bp.route('/children', methods=['POST'])
def create_child():
    data = request.json
    new_id = controller.create(data)
    return jsonify({"message": "Child created", "id": new_id}), 201

@child_bp.route('/children', methods=['HEAD'])
def head_children():
    return jsonify(controller.get_all())

@child_bp.route('/children', methods=['OPTIONS'])
def options_children():
    response = Response()
    response.headers['Allow'] = 'GET, POST, HEAD, OPTIONS'
    return response


@child_bp.route('/children/<int:child_id>', methods=['GET'])
def get_child(child_id):
    child = controller.get_one(child_id)
    if child:
        return jsonify(child)
    return jsonify({"error": "Child not found"}), 404

@child_bp.route('/children/<int:child_id>', methods=['PUT'])
def update_child(child_id):
    data = request.json
    controller.update(child_id, data)
    return jsonify({"message": "Child updated"})

@child_bp.route('/children/<int:child_id>', methods=['PATCH'])
def patch_child(child_id):
    data = request.json
    controller.patch(child_id, data)
    return jsonify({"message": "Child patched"})

@child_bp.route('/children/<int:child_id>', methods=['DELETE'])
def delete_child(child_id):
    controller.delete(child_id)
    return jsonify({"message": "Child deleted"})


@child_bp.route('/children/<int:child_id>/parents', methods=['GET'])
def get_parents(child_id):
    return jsonify(controller.get_parents(child_id))

@child_bp.route('/kindergartens/children', methods=['GET'])
def get_k_children():
    name = request.args.get('name', '')
    return jsonify(controller.get_k_children(name))