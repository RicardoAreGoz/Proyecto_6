from flask import Flask, jsonify, request

app = Flask(__name__)

# Lista de películas de ejemplo
peliculas = [
    {"id": 1, "titulo": "Inception", "director": "Christopher Nolan", "año": 2010},
    {"id": 2, "titulo": "The Matrix", "director": "Lana Wachowski, Lilly Wachowski", "año": 1999},
    {"id": 3, "titulo": "Interstellar", "director": "Christopher Nolan", "año": 2014},
    {"id": 4, "titulo": "Pulp Fiction", "director": "Quentin Tarantino", "año": 1994},
    {"id": 5, "titulo": "The Shawshank Redemption", "director": "Frank Darabont", "año": 1994},
    {"id": 6, "titulo": "The Godfather", "director": "Francis Ford Coppola", "año": 1972},
    {"id": 7, "titulo": "The Dark Knight", "director": "Christopher Nolan", "año": 2008},
    {"id": 8, "titulo": "Forrest Gump", "director": "Robert Zemeckis", "año": 1994},
    {"id": 9, "titulo": "Fight Club", "director": "David Fincher", "año": 1999},
    {"id": 10, "titulo": "The Lord of the Rings: The Return of the King", "director": "Peter Jackson", "año": 2003},
    {"id": 11, "titulo": "Star Wars: Episode IV - A New Hope", "director": "George Lucas", "año": 1977},
    {"id": 12, "titulo": "Back to the Future", "director": "Robert Zemeckis", "año": 1985},
    {"id": 13, "titulo": "Gladiator", "director": "Ridley Scott", "año": 2000},
    {"id": 14, "titulo": "Titanic", "director": "James Cameron", "año": 1997},
    {"id": 15, "titulo": "Avatar", "director": "James Cameron", "año": 2009},
]

# Obtener todas las películas
@app.route('/peliculas', methods=['GET'])
def obtener_peliculas():
    return jsonify({"peliculas": peliculas}), 200

# Obtener una película por ID
@app.route('/peliculas/<int:id>', methods=['GET'])
def obtener_pelicula(id):
    pelicula = next((p for p in peliculas if p["id"] == id), None)
    if pelicula:
        return jsonify({"pelicula": pelicula}), 200
    return jsonify({"mensaje": "Película no encontrada"}), 404

# Agregar una nueva película
@app.route('/peliculas', methods=['POST'])
def agregar_pelicula():
    nueva_pelicula = request.get_json()
    nueva_pelicula["id"] = peliculas[-1]["id"] + 1 if peliculas else 1
    peliculas.append(nueva_pelicula)
    return jsonify({"mensaje": "Película agregada", "pelicula": nueva_pelicula}), 201

# Actualizar una película por ID
@app.route('/peliculas/<int:id>', methods=['PUT'])
def actualizar_pelicula(id):
    pelicula = next((p for p in peliculas if p["id"] == id), None)
    if pelicula:
        datos = request.get_json()
        pelicula.update(datos)
        return jsonify({"mensaje": "Película actualizada", "pelicula": pelicula}), 200
    return jsonify({"mensaje": "Película no encontrada"}), 404

# Eliminar una película por ID
@app.route('/peliculas/<int:id>', methods=['DELETE'])
def eliminar_pelicula(id):
    global peliculas
    peliculas = [p for p in peliculas if p["id"] != id]
    return jsonify({"mensaje": "Película eliminada"}), 200

# Ejecutar el servidor
if __name__ == '__main__':
    app.run(debug=True)
