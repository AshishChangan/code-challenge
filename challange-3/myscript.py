
def getKey(obj: dict):
    keys = list(obj)
    return keys[0]


def getNestedValue(obj: dict, key: str, isPresent = False):
    if type(obj) is not dict and not isPresent:
        return None
    if (isPresent or (key in obj.keys())) :
        if type(obj[key]) is dict:
            return getNestedValue(obj[key], getKey(obj[key]), True)
        else:
            return obj[getKey(obj)]
    else:
        nestedKey = getKey(obj)
        return getNestedValue(obj[nestedKey], key, False)

if __name__ == '__main__':
    obj = {'a': {'b': {'c': 'd'}}}
    value = getNestedValue(obj, 'c')
    print(value)