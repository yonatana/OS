all: 

clone:
	git clone https://github.com/dtolpin/espl131-handouts
push: 
  
	git add $(file)
	git commit -a -m "$(file)"
	git push origin master
per:
	chmod +x "filename"