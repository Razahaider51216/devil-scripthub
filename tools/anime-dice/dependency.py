"""Read the verified immutable GUI dependency, downloading only if uncached."""
from pathlib import Path
import hashlib, urllib.request

URL = 'https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau'
SHA256 = '0c30762d3c9c3aa7c25ca3aeceab960a771c96b5af290a3b67aed627161385f5'

def read(root):
    path = root.parent / 'chilli-ui-redesign/ouroflow-main.luau'
    if path.is_file():
        data = path.read_bytes()
    else:
        with urllib.request.urlopen(URL, timeout=25) as response:
            data = response.read()
    assert hashlib.sha256(data).hexdigest() == SHA256, 'Pinned GUI dependency integrity mismatch'
    return data
