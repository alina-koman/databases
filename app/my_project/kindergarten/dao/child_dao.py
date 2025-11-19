from app.config.db import get_db_connection

class ChildDAO:
    def get_all(self):
        conn = get_db_connection()
        if conn is None: return []
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM children")
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result

    def get_by_id(self, child_id):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM children WHERE child_id = %s", (child_id,))
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        return result

    def create(self, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        sql = "INSERT INTO children (first_name, last_name, birth_date) VALUES (%s, %s, %s)"
        val = (data['first_name'], data['last_name'], data['birth_date'])
        cursor.execute(sql, val)
        conn.commit()
        new_id = cursor.lastrowid
        cursor.close()
        conn.close()
        return new_id

    def update(self, child_id, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        sql = "UPDATE children SET first_name = %s, last_name = %s, birth_date = %s WHERE child_id = %s"
        val = (data['first_name'], data['last_name'], data['birth_date'], child_id)
        cursor.execute(sql, val)
        conn.commit()
        cursor.close()
        conn.close()

    def delete(self, child_id):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        cursor.execute("DELETE FROM children WHERE child_id = %s", (child_id,))
        conn.commit()
        cursor.close()
        conn.close()
    
    def patch(self, child_id, data):
        conn = get_db_connection()
        if conn is None: return None
        cursor = conn.cursor()
        
        fields = []
        values = []
        if 'first_name' in data:
            fields.append("first_name = %s")
            values.append(data['first_name'])
        if 'last_name' in data:
            fields.append("last_name = %s")
            values.append(data['last_name'])
        if 'birth_date' in data:
            fields.append("birth_date = %s")
            values.append(data['birth_date'])
            
        if not fields:
            return
            
        sql = f"UPDATE children SET {', '.join(fields)} WHERE child_id = %s"
        values.append(child_id)
        
        cursor.execute(sql, tuple(values))
        conn.commit()
        cursor.close()
        conn.close()

    def get_parents_by_child(self, child_id):
        conn = get_db_connection()
        if conn is None: return []
        cursor = conn.cursor(dictionary=True)
        sql = """
        SELECT p.parent_id, p.first_name, p.last_name, p.phone_number, cp.relation_type
        FROM parents p
        JOIN child_parents cp ON p.parent_id = cp.parent_id
        WHERE cp.child_id = %s
        """
        cursor.execute(sql, (child_id,))
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result

    def get_children_in_kindergarten(self, kindergarten_name):
        conn = get_db_connection()
        if conn is None: return []
        cursor = conn.cursor(dictionary=True)
        sql = """
        SELECT c.first_name, c.last_name, g.name as group_name, k.name as kindergarten_name
        FROM children c
        JOIN child_enrollment ce ON c.child_id = ce.child_id
        JOIN child_groups g ON ce.group_id = g.group_id
        JOIN kindergartens k ON g.kindergarten_id = k.kindergarten_id
        WHERE k.name LIKE %s
        """
        cursor.execute(sql, (f"%{kindergarten_name}%",))
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result