import json
import urllib2
import uuid
import hmac
import hashlib


#parameters send to MoMo get get payUrl
def momoPayment(partnerCode,orderId,amount):
	accessKey = "F8BBA842ECF85"
	serectkey = "K951B6PE1waDMi640xX08PD3vg6EkVlz"
	orderInfo = "pay with MoMo"
	returnUrl = "https://momo.vn/return"
	notifyurl = "https://dummy.url/notify"
	endpoint = "https://test-payment.momo.vn/gw_payment/transactionProcessor"
	requestId = str(uuid.uuid4())
	requestType = "captureMoMoWallet"
	extraData = "merchantName=;merchantId="
	rawSignature = "partnerCode="+partnerCode+"&accessKey="+accessKey+"&requestId="+requestId+"&amount="+amount+"&orderId="+orderId+"&orderInfo="+orderInfo+"&returnUrl="+returnUrl+"&notifyUrl="+notifyurl+"&extraData="+extraData




	#orderId = str(uuid.uuid4())



	h = hmac.new( serectkey, rawSignature, hashlib.sha256 )
	signature = h.hexdigest()

	data = {
			'partnerCode' : partnerCode,
			'accessKey' : accessKey,
			'requestId' : requestId,
			'amount' : amount,
			'orderId' : orderId,
			'orderInfo' : orderInfo,
			'returnUrl' : returnUrl,
			'notifyUrl' : notifyurl,
			'extraData' : extraData,
			'requestType' : requestType,
			'signature' : signature
	}
	data = json.dumps(data)

	clen = len(data)
	req = urllib2.Request(endpoint, data, {'Content-Type': 'application/json', 'Content-Length': clen})
	f = urllib2.urlopen(req)

	response = f.read()
	f.close()
	url = json.loads(response)['payUrl']
	
	return str(url)