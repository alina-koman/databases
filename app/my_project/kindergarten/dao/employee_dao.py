from app.config.db import get_db_connection

class EmployeeDAO:
    def get_all(self):
        conn = get_db_connection()
        if conn is None: return []
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM employees")
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result

    def get_by_id(self, employee_id):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM employees WHERE employee_id = %s", (employee_id,))
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        return result

    def create(self, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        sql = """
        INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, kindergarten_id) 
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        val = (
            data['first_name'], 
            data['last_name'], 
            data.get('email'), 
            data.get('phone_number'),
            data['hire_date'],
            data['kindergarten_id']
        )
        cursor.execute(sql, val)
        conn.commit()
        new_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return new_id

    def update(self, employee_id, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        sql = """
        UPDATE employees SET 
            first_name = %s, 
            last_name = %s, 
            email = %s, 
            phone_number = %s, 
            hire_date = %s, 
            kindergarten_id = %s 
        WHERE employee_id = %s
        """
        val = (
            data['first_name'], 
            data['last_name'], 
            data.get('email'), 
            data.get('phone_number'),
            data['hire_date'],
            data['kindergarten_id'],
            employee_id
        )
        cursor.execute(sql, val)
        conn.commit()
        cursor.close()
        conn.close()

    def delete(self, employee_id):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        cursor.execute("DELETE FROM employees WHERE employee_id = %s", (employee_id,))
        conn.commit()
        cursor.close()
        conn.close()

    def patch(self, employee_id, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        
        fields = []
        values = []
        # Перевіряємо всі можливі поля
        if 'first_name' in data:
            fields.append("first_name = %s")
            values.append(data['first_name'])
        if 'last_name' in data:
            fields.append("last_name = %s")
            values.append(data['last_name'])
        if 'email' in data:
            fields.append("email = %s")
            values.append(data['email'])
        if 'phone_number' in data:
            fields.append("phone_number = %s")
            values.append(data['phone_number'])
        if 'hire_date' in data:
            fields.append("hire_date = %s")
            values.append(data['hire_date'])
        if 'kindergarten_id' in data:
            fields.append("kindergarten_id = %s")
            values.append(data['kindergarten_id'])
            
        if not fields:
            return
            
        sql = f"UPDATE employees SET {', '.join(fields)} WHERE employee_id = %s"
        values.append(employee_id)
        
        cursor.execute(sql, tuple(values))
        conn.commit()
        cursor.close()
        conn.close()