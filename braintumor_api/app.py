import cv2
import numpy as np
import base64
from ultralytics import YOLO
import io
import logging
import os
from fastapi import FastAPI, Form, Request, status, File, UploadFile, HTTPException
from fastapi.responses import HTMLResponse, FileResponse, RedirectResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import uvicorn



app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")


# Setup logging
logging.basicConfig(level=logging.INFO)

# Load the YOLO model
try:
    model = YOLO('yolo_50epoch.pt')  # Ensure the model filename is correct
    
except Exception as e:
    logging.error(f"Failed to load model: {e}")
    raise RuntimeError("Model loading failed")

def detect_objects(image):
    try:
        # Run inference on the input image
        results = model(image)
        if not results:
            return None
        # Process each result in the list
        for result in results:
            # Plot the detection results on the original image
            annotated_image = result.plot()

            # Convert the annotated image to bytes
            _, img_encoded = cv2.imencode('.png', annotated_image)

        return img_encoded
    except Exception as e:
        logging.error(f"Error in object detection: {e}")
        return None

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    print('Request for index page received')
    return templates.TemplateResponse('index.html', {"request": request})

@app.get('/favicon.ico')
async def favicon():
    file_name = 'favicon.ico'
    file_path = './static/' + file_name
    return FileResponse(path=file_path, headers={'mimetype': 'image/vnd.microsoft.icon'})

@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    if not file.filename.lower().endswith((".png", ".jpg", ".jpeg")):
        raise HTTPException(status_code=400, detail="Invalid file type")

    # Read image into memory
    image_data = await file.read()
    # Convert to a NumPy array
    nparr = np.frombuffer(image_data, np.uint8)
    # Decode image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # Call the object detection method
    result = detect_objects(img)
    if result is None:
        raise HTTPException(status_code=500, detail="Failed to process image")

    # Convert the results back to a file response
    return FileResponse(result.tobytes(), media_type="image/png", filename="result.png")


#@app.post('/detect', response_class=HTMLResponse)
#def detect():
#    if 'image' not in request.files:
#        return jsonify({'error': 'No image provided'}), #
#    file = request.files['image']
#    nparr = np.frombuffer(file.read(), np.uint8)
#    image = cv2.imdecode(nparr, cv2.#
#    if image is None:
#        return jsonify({'error': 'Invalid image format'}), #
#    detection_results = detect_objects(image)
#    if detection_results is None:
#        return jsonify({'error': 'Detection failed or no objects detected'}), #
#    img_bytes = io.BytesIO(detection_results)
#    return send_file(img_bytes, mimetype='image/png')

if __name__ == '__main__':
    uvicorn.run('app:app', host='0.0.0.0')
