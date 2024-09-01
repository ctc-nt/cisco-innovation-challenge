from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
from python_terraform import Terraform

app = FastAPI()

class TerraformRequest(BaseModel):
    operation: str
    network_type: str
    options: Optional[dict]

@app.post("/terraform/")
def manage_terraform(request: TerraformRequest):
    tf = Terraform(working_dir=request.network_type)
    if request.options:
        return tf.cmd(request.operation, **request.options)
    else:
        return tf.cmd(request.operation)