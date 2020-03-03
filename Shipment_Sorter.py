class Item:
	def __init__(self, Name, Id, Price):
		self.Name = Name
		self.Id = Id 
		self.Price = Price
		
	def getName(self):
		return self.Name
	
	def getId(self):
		return self.Id
		
	def getPrice(self):
		return self.Price
		
	def __str__(self):
		return str(self.Name) + " " + str(self.Id) + " " + str(self.Price)

class Shipment:
	def __init__(self, Id):
		self.Id = Id
		self.items = []
	
	def getId(self):
		return self.Id
	
	def getItems(self):
		return self.items
	
	def addItem(self, Item):
		self.items.append(Item)	
	
	def __str__(self):
		shipment = str(self.Id) + ":" + " ["
		ctr = 0
		while ctr < len(self.items):
			shipment += str(self.items[ctr])
			if ctr < len(self.items) - 1:
				shipment += ","
			ctr += 1
		shipment += "]"
		#print shipment
		return shipment 
class ItemException(Exception):
	def __init__(self, message):
		self.message = message
		self.items = []

	def __str_(self):
		return str(self.message)

class PriceException(Exception):
	def __init__(self, message):
		self.message = message
		self.items = []

	def __str_(self):
		return str(self.message)

def processFile(filename):
	file = open(filename, "r+")
	lines = file.readlines()
	new_file = []  
	for line in lines:
		new_file.append(line)
	file.close()
	#print new_file
	return new_file

def main(list1, list2):
	truck = []
	ctr1 = 0
	while ctr1 < len(list1):
		if list1[ctr1][:-1].isdigit() == True:
			ship = Shipment(list1[ctr1][:-1]) 
			truck.append(ship)
			ctr1 += 1
			
		ctr2 = 0
		while ctr2 < len(list1[ctr1]):
			if list1[ctr1][ctr2] == " ":        
				name = str(list1[ctr1][0:ctr2])                                
				id = list1[ctr1][ctr2 + 1:-1]                                        
				price = str(list1[ctr1 + 1][:-1])
				
				if len(id) > 5:
					raise ItemException(Exception)
				
				if ctr2 < len(price):
					
					if price[ctr2] < 0:
						raise PriceException(Exception)
					
					if len(price) > 5:
						raise PriceException(Exception)
				
				if price[1].isdigit() == False:
					raise PriceException(Exception)
				
				if price[2].isdigit() == False:
					
					if price[2] != ".":
						raise PriceException(Exception)
				
				if price[0] != "$":
					raise ItemException(Exception)
				
				else:
					item = Item(name, id, price)
					ship.addItem(item)
			ctr2 += 1
			
		else: 
			if " " not in list1[ctr1]:                
				raise ItemException(Exception)
				
		ctr1 += 2
	return truck
