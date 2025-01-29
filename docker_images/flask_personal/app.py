from flask import Flask, render_template, jsonify,send_from_directory
import logging

app = Flask(__name__)

# Configurar logging
logging.basicConfig(level=logging.INFO)

@app.route('/api', methods=['GET'])
def hello_world():
    """
    Endpoint que devuelve una página HTML más elaborada.
    
    Returns:
        str: Una página HTML servida con el archivo `index.html`.
    """
    logging.info("Se ha accedido al endpoint /api")
    return render_template('index.html')

# Manejo de errores
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "No encontrado"}), 404

@app.errorhandler(Exception)
def handle_exception(error):
    """Manejo genérico de excepciones."""
    logging.error(f"Ocurrió un error: {error}")
    return jsonify({"error": str(error)}), 500

@app.route('/api/static/<path:filename>')
def serve_static(filename):
    return send_from_directory('static', filename)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
