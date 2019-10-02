import nltk.classify.util
import pandas as pd
from nltk.classify import NaiveBayesClassifier
import re

url = "/Users/VishalDubey/Desktop/ML/train.csv"
file = open("key_log.txt", "r")
contents=file.readlines()
def readData(contents):
	ls = [x.replace('\n','').replace('\'', '') for x in contents]
	tmp = ""
	array = []
	count = 0
	for i in ls:
		if(i.find('.')==-1):
			tmp += i
		elif(i=='Key.space'):
			tmp += " "
			count+=1
		elif(count>=10):
			array.append(tmp)
			tmp = ""
			count = 0
		else:
			continue
	return array
array = readData(contents)
#print(array)
dataset = pd.read_csv(url, index_col = None)

pos = []
neg = []
for x in range(len(dataset.twt)):
	if(dataset.y[x]>2):
		pos.append(dataset.twt[x])
	elif(dataset.y[x]<2):
		neg.append(dataset.twt[x])

REPLACE_NO_SPACE = re.compile("[.;:!\'?,\"()\[\]]")
REPLACE_WITH_SPACE = re.compile("(<br\s*/><br\s*/>)|(\-)|(\/)")
def preprocess_reviews(ret):
   ret = [REPLACE_NO_SPACE.sub("", line.lower()) for line in ret]
   ret = [REPLACE_WITH_SPACE.sub(" ", line) for line in ret]
   return ret

pos = preprocess_reviews(pos)
neg = preprocess_reviews(neg)


def removeA(ls):
	for i in range(len(ls)):
		if(ls[i][0]=='@'):
			ls[i] = ls[i].split(" ")[1:]
		else:
			ls[i] = ls[i].split(" ")[0:]
	return ls

neg = removeA(neg)
pos = removeA(pos)


def extract(word_list):
	return dict([(word, True) for word in word_list])

def extract2(word_list):
	return dict([(word, True) for word in word_list.split(" ")])

def reformat(ls, typ):
	features = []
	for sent in ls:
		features.append((extract(sent), typ))
	return features

def reformat2(ls, typ):
	features = []
	for sent in ls:
		features.append((extract2(sent), typ))
	return features

features_positive = reformat(pos, 'Positive')
features_negative = reformat(neg, 'Negative')
features_negative2 = reformat2(array, 'Negative')
threshold_factor = 0.8
threshold_positive = int(threshold_factor * float(len(features_positive)))
threshold_negative = int(threshold_factor * float(len(features_negative)))
features_train = features_positive[:threshold_positive] + features_negative[:threshold_negative] + features_negative2
features_test = features_positive[threshold_positive:] + features_negative[threshold_negative:]
classifier = nltk.NaiveBayesClassifier.train(features_train)
#print("\nAccuracy of the classifier:", nltk.classify.util.accuracy(classifier, features_test))


#print(features_negative2)
inputs = open('key_log2.txt', "r", encoding="utf-8")
content2 = readData(inputs.readlines())
posCount = 0
negCount = 0
print(content2)
for i in content2:
	#print("\nInput:", i)
	probdist = classifier.prob_classify(extract(i.split()))
	pred_sentiment = probdist.max()
	
	if(pred_sentiment=="Negative"):
		negCount+=1
	else:
		posCount +=1
posRatio = posCount/(negCount+posCount)
negRatio = negCount/(negCount+posCount)
if(posRatio > negRatio):
	print("Predicted sentiment: "+str(round(posRatio*100, 2))+"% chance of being POSITIVE")
else:
	print("Predicted sentiment: "+str(round(negRatio*100, 2))+"% chance of being NEGATIVE")

	#print("Predicted sentiment:", pred_sentiment)
	#print("Probability:", round(probdist.prob(pred_sentiment), 2))
	#



