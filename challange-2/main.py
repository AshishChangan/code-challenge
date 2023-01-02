import json

from extract import json_extract
r = json.loads(open('metadata.json').read())
data_values = json_extract(r, 'attributes')
print(data_values)
