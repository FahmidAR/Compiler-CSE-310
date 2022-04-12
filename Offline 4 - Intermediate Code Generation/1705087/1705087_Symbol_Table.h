#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H


struct symbolInfo
{
    symbolInfo *next;

    private :
    string name , type  ;

    string idType ="" , varType ="", parameterList ="", returnType , asmCode , asmVar; // idT :Variable/Array varT:
    int arrayIndex = -1 , arraySize =-1 ;

    public :


    symbolInfo(string nameS , string typeS) // normal
    {
        this->name = nameS ;
        this->type = typeS ;
        this->returnType ="dummy";
        this->asmCode="" ;
        this->asmVar="" ;
    }

    symbolInfo(string nameS , string typeS, string returnTypeS ) // normal 2
    {
        this->name = nameS ;
        this->type = typeS ;
        this->returnType = returnTypeS ;
        this->asmCode="" ;
        this->asmVar="" ;

    }

    symbolInfo(string nameS , string typeS, string idTypeS, string varTypeS) // varribale
    {
        this->name = nameS ;
        this->type = typeS ;
        this->idType = idTypeS ;
        this->varType = varTypeS ;
        this->returnType ="dummy";
        this->asmCode="" ;
        this->asmVar="" ;
    }

       symbolInfo(string nameS , string typeS, string idTypeS, int arrayIndexS ) /// array
    {
        this->name = nameS ;
        this->type = typeS ;
        this->idType = idTypeS ;
        this->arrayIndex = arrayIndexS ;
        this->returnType ="dummy";
        this->asmCode="" ;
        this->asmVar="" ;

    }

       symbolInfo(string nameS , string typeS, string idTypeS, string returnTypeS , string parameterListS) // funtion
    {
        this->name = nameS ;
        this->type = typeS ;
        this->idType = idTypeS ;
        this->returnType = returnTypeS ;
        this->parameterList = parameterListS ;
        this->asmCode="" ;
        this->asmVar="" ;
    }
    
    void setAVAR(string nameS)
    {
        this->asmVar = nameS ;
    }
    
    void setCode(string nameS)
    {
        this->asmCode = nameS ;
    }
    void setName(string nameS)
    {
        this->name = nameS ;
    }
    void setType (string typeS)
    {
        this->type = typeS ;
    }
    void setidType(string idTypeS)
    {
        this->idType = idTypeS ;
    }
    void setvarType (string varTypeS)
    {
        this->varType = varTypeS ;
    }
    void setreturnType(string returnTypeS)
    {
        this->returnType = returnTypeS ;
    }
    void setparameterList (string parameterListS)
    {
        this->parameterList = parameterListS ;
    }
    void setarrayIndex(int arrayIndexS)
    {
        this->arrayIndex = arrayIndexS ;
    }



    string getAVAR()
    {
        return asmVar;
    }
    string getCode()
    {
        return asmCode;
    }
    string getName()
    {
        return name ;
    }
    string getType()
    {
        return type ;
    }
     string getidType()
    {
        return idType ;
    }
    string getvarType()
    {
        return varType ;
    }
     string getreturnType()
    {
        return returnType ;
    }
    string getparameterList()
    {
        return parameterList ;
    }
    int getarrayIndex()
    {
        return arrayIndex ;
    }

    ~symbolInfo()
    {
       delete next;
    }

};

class scopeTable
{
     public:

    int currentID = 1;
    int nextID = 1;
    string version =" ";

    int curentSize , b_no;

    scopeTable* parent = NULL ;
    symbolInfo** hashTable;

    scopeTable(int bucketNo)
    {
        this->b_no= bucketNo;

        hashTable = new symbolInfo*[b_no];
        this->curentSize=0;

        for (int i = 0; i < b_no ; i++)
        {
            hashTable[i] = NULL;
        }
    }

    string toString(auto &i)
    {
       stringstream ss;
       ss << i;
       return ss.str();
    }

    int stringToKey(string s)
    {
        int key = 0 ;

        for(int i=0; s[i] ;i++)
        {
            //cout<<s[i]<<endl;
            key = key+s[i];
        }

        //cout<<key<<endl;
        return key;
    }


    bool searchHash(string name,bool label)
    {

        int ind = hashFun(name);
        int pos = -1;
        symbolInfo* entry = hashTable[ind];

        while (entry != NULL)
        {
            pos++;
            if (entry->getName() == name)
            {
                if(label)
                {
                    logFile<<"Found in ScopeTable# "<<version<<" at position "<<ind<<" , "<<pos<<endl;
                }

                return true;
            }
            entry = entry->next;
        }
        if(label)
        {
            //cout<<"NOT FOUND in ScopeTable"<<endl;
        }

        return false;
    }

    symbolInfo* searchHashAddress(string name)
    {

        int ind = hashFun(name);
        int pos = -1;
        symbolInfo* entry = hashTable[ind];

        while (entry != NULL)
        {
            pos++;
            if (entry->getName() == name)
            {
                return entry;
            }
            entry = entry->next;
        }

        return NULL;
    }

    bool insertHash(string name, string type)
    {

            if(searchHash(name,true))
            {
                logFile<<"<"<<name<<" , "<<searchHashAddress(name)->getType()<<"> already exists in current ScopeTable"<<endl;
                return false ;
            }

            int ind=hashFun(name);
            int pos = 0;
            symbolInfo * prev = NULL;
            symbolInfo* entry = hashTable[ind];

            while (entry != NULL)
            {
                prev = entry;
                entry = entry->next;
                pos++;
            }

            if (entry == NULL)
            {
                //cout<<"mew"<<endl;

                entry = new symbolInfo(name,type);

                if (prev == NULL)
                {
                    hashTable[ind] = entry;
                    //cout<<entry->getName()<<endl;

                }
                else
                {
                    prev->next = entry;
                }
            }
            else
            {
                entry->setName(name) ;
                entry->setType(type) ;
            }
            //cout<<hashTable[ind]->getName()<<endl;
        logFile<<"Inserted in ScopeTable# "<<version<<" at position "<<ind<<" , "<<pos<<endl;
        this->curentSize++;
        return true;
    }

    void printHash()
    {
        logFile<<"ScopeTable # "<<version<<endl;
        for (int i = 0; i < b_no ; i++) {
            if (hashTable[i] != NULL)
            {

                 logFile <<i;
                 symbolInfo* entry = hashTable[i];

                while (entry != NULL)
                {
                    logFile <<" -->  <"<< entry->getName()<<" : "<<entry->getType() <<" >  ";
                    entry = entry->next;
                }

                logFile << endl;

            }
            /* else
            {
                 logFile << i <<" -->"<<endl;
            } */
        }
    }

    bool deleteHash(string name)
    {
        if(!searchHash(name,true))
        {
        logFile<<"Not found"<<endl;
        logFile<<endl;
        logFile<<name<<" not found"<<endl;

        return false ;
        }


        int ind = hashFun(name);
        int pos =0;
        symbolInfo* prev = NULL;
        symbolInfo* entry = hashTable[ind];
        bool flag = false;

        if (entry == NULL )
        {
        return false;
        }
        if(entry->getName()==name)
        {
        hashTable[ind]=entry->next;
        logFile<<"Deleted Entry "<<ind<<" , "<<pos<<" from current ScopeTable"<<endl;
        return true;
        }

        while (entry->next != NULL)
        {
        pos++;
        prev = entry;
        entry = entry->next;

        if(entry->getName()==name)
        {
        flag=true;
        break;
        }

        }
        if (prev != NULL)
        {
        prev->next = entry->next;
        }

        delete entry;

        logFile<<"Deleted Entry "<<ind<<" , "<<pos<<" from current ScopeTable"<<endl;
        return true;
    }

    int hashFun(string key)
    {
        int keyI=stringToKey(key);

        return (keyI % b_no);


    }

    ~scopeTable()
    {

    delete parent;

    for (int i = 0; i < b_no; i++)

    {

        symbolInfo* entryN = hashTable[i];

        while (entryN != NULL)

        {

            symbolInfo* prev = entryN;

            entryN = entryN->next;

            delete prev;

        }

        delete[] hashTable;

    }
    }

};


class symbolTable
{

    public:

    //freopen ("output.txt","w",stdout);

    int bNO;
    scopeTable *current ;

    symbolTable(int n)
    {
        this->bNO=n;
        current =new scopeTable(n);
        current->version="1";
    }

    string toString(auto &i)
    {
       stringstream ss;
       ss << i;
       return ss.str();
    }

    void enterScope()
    {
        scopeTable* temp = this->current;
        int t = this->current->nextID;


        this->current = new scopeTable(bNO);
        this->current->parent = temp;

        this->current->currentID = t;

        if(this->current->parent!=NULL)
        {
            this->current->version = this->current->parent->version+"."+toString(this->current->currentID);
        }
        else
        {
            this->current->version =toString(this->current->currentID);
        }

        logFile<<"New ScopeTable with id "<<this->current->version<<" created"<<endl;
    }

    void exitScope()
    {
        logFile<<"ScopeTable with id "<<this->current->version<<" removed"<<endl;

        scopeTable* temp =(this->current->parent)->parent;
        this->current = this->current->parent;
        this->current->parent = temp;
        this->current->nextID = this->current->nextID + 1;
    }
    bool insertScope(string name , string type)
    {
        return this->current->insertHash(name,type);
    }

    void removeScope(string name)
    {
        this->current->deleteHash(name);
    }

    symbolInfo* lookupAllScope(string name )
    {
        scopeTable *temp = current;

        while(temp!=NULL)
        {
           if(temp->searchHash(name,true))
           {
               return temp->searchHashAddress(name);
           }
           else
           {
              temp=temp->parent;
           }
        }
        logFile<<"Not found"<<endl;
        return NULL;
    }

    void printCurrentScope()
    {
        logFile<<endl;
        this->current->printHash();
    }

    void printAllScope()
    {
        scopeTable* temp = current;
        while(temp!=NULL)
        {
            logFile<<endl;
            temp->printHash();
            temp = temp->parent ;
        }
        logFile<<endl;
    }

    ~symbolTable()
    {
        while(current->parent!=NULL)
        {
            current=current->parent;
        }
       delete current;
    }

};




#endif // SYMBOLINFO_H
