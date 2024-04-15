#from fastapi import FastAPI, Form, Request, status
#from fastapi.responses import HTMLResponse, FileResponse, RedirectResponse
#from fastapi.staticfiles import StaticFiles
#from fastapi.templating import Jinja2Templates
#import uvicorn
#
#
#app = FastAPI()
#app.mount("/static", StaticFiles(directory="static"), name="static")
#templates = Jinja2Templates(directory="templates")
#
#@app.get("/", response_class=HTMLResponse)
#async def index(request: Request):
#    print('Request for index page received')
#    return templates.TemplateResponse('index.html', {"request": request})
#
#@app.get('/favicon.ico')
#async def favicon():
#    file_name = 'favicon.ico'
#    file_path = './static/' + file_name
#    return FileResponse(path=file_path, headers={'mimetype': 'image/vnd.microsoft.icon'})
#
#@app.post('/hello', response_class=HTMLResponse)
#async def hello(request: Request, name: str = Form(...)):
#    if name:
#        print('Request for hello page received with name=%s' % name)
#        return templates.TemplateResponse('hello.html', {"request": request, 'name':name})
#    else:
#        print('Request for hello page received with no name or blank name -- redirecting')
#        return RedirectResponse(request.url_for("index"), status_code=status.HTTP_302_FOUND)
#
#if __name__ == '__main__':
#    uvicorn.run('main:app', host='0.0.0.0')
#


import cv2
import numpy as np
import base64
from ultralytics import YOLO
import io
import logging
import os
from fastapi import FastAPI, Form, Request, status, File, UploadFile, HTTPException
from fastapi.responses import HTMLResponse, FileResponse, RedirectResponse, JSONResponse, Response
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import uvicorn

from threading import Thread
from typing import Callable, Any


app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

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

@app.post('/hello', response_class=HTMLResponse)
async def hello(request: Request, name: str = Form(...)):
    if name:
        print('Request for hello page received with name=%s' % name)
        return templates.TemplateResponse('hello.html', {"request": request, 'name':name})
    else:
        print('Request for hello page received with no name or blank name -- redirecting')
        return RedirectResponse(request.url_for("index"), status_code=status.HTTP_302_FOUND)


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
    
    print("Result type:", type(result))
    print("Result array shape:", result.shape)  # Useful if result is a NumPy array

    if result.size == 0:
        raise HTTPException(status_code=500, detail="Image processing failed or returned empty result")

    return Response(content=result.tobytes(), media_type="image/png")
    # Convert the results back to a file response
    #return FileResponse(result.tobytes(), media_type="image/png", filename="result.png")
    
if __name__ == '__main__':
    uvicorn.run('main:app', host='0.0.0.0')
