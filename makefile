all: 

clone:
	git clone https://github.com/dtolpin/espl131-handouts
push: 
  
	git add $(File)
	git commit -a -m "$(File)"
	git push origin master
per:
	chmod +x "filename"