from diffusers import DiffusionPipeline
from PIL import Image
import safetensors.torch
import torch
from torchvision.transforms import ToPILImage

model_id = "AstraliteHeart/pony-diffusion"
prompt = "yuuka-default"

pipeline = DiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16)
pipeline.to("cuda")

state_dict = safetensors.torch.load_file("./generator/yuuka_blue_archive_PONY_last.safetensors")

pipeline.load_lora_weights("./generator/yuuka_blue_archive_PONY_last.safetensors", adapter_name="pixel")

lora_scale = 0.9
img = pipeline(prompt, num_inference_steps=30, cross_attention_kwargs={"scale": lora_scale}, generator=torch.manual_seed(0)).images[0]
tf_to_pil = ToPILImage()
pil_img = tf_to_pil(img)

pil_img.show()
