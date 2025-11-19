from flask import Flask
from app.my_project.kindergarten.route.child_route import child_bp
from app.my_project.kindergarten.route.employee_route import employee_bp 

app = Flask(__name__)

app.register_blueprint(child_bp)
app.register_blueprint(employee_bp)  

if __name__ == '__main__':
    app.run(debug=True)