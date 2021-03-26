from flask import Flask, request, jsonify
import werkzeug
app = Flask(__name__)

@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST" :
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        print("\nReceived image File name : " + imagefile.filename)
        imagefile.save("./uploadedimages/" + filename)
        
        return jsonify({
            "message": "Image Uploaded Successfully ",
        })

if __name__ == "__main__":
    app.run(debug=True, port=9000)



