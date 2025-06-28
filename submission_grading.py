# input t is a tuple, return the multiset
# eg, input = ('jennybeckham1992@gmail.com', datetime.date(2023, 7, 27))
# expected return is {'jennybeckham1992@gmail.com': 1, datetime.date(2023, 7, 27): 1}
def value_count(t):
    res = {}
    for x in t:
        res[x] = res.get(x, 0) + 1
    return res

def tuple_similarity(t1, t2):
    d1 = value_count(t1)
    d2 = value_count(t2)
    intersection = {}
    union = {}
    for k, v in d1.items():
        intersection[k] = min(v, d2.get(k, 0))
    union[k] = max(v, d2.get(k, 0))
    #Missing codes here
    intersection = sum(intersection.values())
    union = sum(union.values())
    return 0.0 if union == 0 else intersection/union

def rs_similarity(set1, set2):
    s1, s2 = [], []
    for t1 in set1:
        temp = []
    for t2 in set2:
        score = tuple_similarity(t1, t2)
    temp.append(score)
    s1.append(0.0 if len(temp)== 0 else max(temp))
    #Missing codes here
    s1.extend(s2)
    score = 0.0 if len(s1)==0 else sum(s1)/len(s1)
    return score