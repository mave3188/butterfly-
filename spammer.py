import base64
data = "<base64_string_panjang>"
data += '=' * (-len(data) % 4)   
exec(base64.b64decode(data).decode())