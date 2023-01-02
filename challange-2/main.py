import json
from extract import json_extract
fileobj = open('allMetadata1.json')
jsonstr = fileobj.read()
#fileobj.close()
# do character conversion here
outstr = jsonstr.replace('"{', '{').replace('}"', '}')
# print the converted string
with open('allMetadata1.json', 'w') as f:
    f.writelines(outstr)
fileobj.close()
f.close()
r = json.loads(open('allMetadata1.json').read())
data_values = json_extract(r, 'expireOn')
print(data_values)
