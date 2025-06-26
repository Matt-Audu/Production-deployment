from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
from datetime import datetime
import uvicorn

app = FastAPI()

Instrumentator().instrument(app).expose(app)

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow().isoformat() + "Z"}

@app.get("/items")
async def get_items():
    return {"items": ["item1", "item2", "item3"]}

@app.post("/items")
async def create_item(item: dict):
    return {"message": "Item created", "item": item}

@app.get("/healthz")
async def healthz():
    return {"status": "ok"}





