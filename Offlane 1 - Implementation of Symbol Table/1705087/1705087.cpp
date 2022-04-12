#include<bits/stdc++.h>
using namespace std;
#include<string>

#define FILE 1

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

struct symbolInfo
{
    symbolInfo *next;

    private :
    string name , type ;

    public :
    symbolInfo(string nameS , string typeS)
    {
        this->name = nameS ;
        this->type = typeS ;
    }

    void setName(string nameS)
    {
        this->name = nameS ;
    }
    void setType (string typeS)
    {
        this->type = typeS ;
    }
    string getName()
    {
        return name ;
    }
    string getType()
    {
        return type ;
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

    bool insertHash(string name, string type);
    bool searchHash(string name,bool label);
    symbolInfo* searchHashAddress(string name);
    bool deleteHash(string name);
    void printHash();

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

bool scopeTable::deleteHash(string name)
{
    if(!searchHash(name,true))
    {
        cout<<"Not found"<<endl;
        cout<<endl;
        cout<<name<<" not found"<<endl;

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
       cout<<"Deleted Entry "<<ind<<" , "<<pos<<" from current ScopeTable"<<endl;
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

    cout<<"Deleted Entry "<<ind<<" , "<<pos<<" from current ScopeTable"<<endl;
    return true;
}

bool scopeTable::searchHash(string name,bool label)
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
                cout<<"Found in ScopeTable# "<<version<<" at position "<<ind<<" , "<<pos<<endl;
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

symbolInfo* scopeTable::searchHashAddress(string name)
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

bool scopeTable::insertHash(string name, string type)
{

        if(searchHash(name,true))
        {
            cout<<"<"<<name<<" , "<<type<<"> already exists in current ScopeTable"<<endl;
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
    cout<<"Inserted in ScopeTable# "<<version<<" at position "<<ind<<" , "<<pos<<endl;
    this->curentSize++;
    return true;
}

void scopeTable::printHash()
{
    cout<<"ScopeTable # "<<version<<endl;
    for (int i = 0; i < b_no ; i++) {
        if (hashTable[i] != NULL)
        {

             cout <<i;
             symbolInfo* entry = hashTable[i];

            while (entry != NULL)
            {
                cout <<" -->  <"<< entry->getName()<<" : "<<entry->getType() <<" >  ";
                entry = entry->next;
            }

            cout << endl;

        }
        else
        {
             cout << i <<" -->"<<endl;
        }
    }
}

class symbolTable
{
    public:

    int bNO;
    scopeTable *current ;

    symbolTable(int n)
    {
        this->bNO=n;
        current =new scopeTable(n);
        current->version="1";
    }

    void enterScope();
    void exitScope();
    void insertScope(string name , string type);
    void removeScope(string name );
    symbolInfo* lookupAllScope(string name);
    void printCurrentScope();
    void printAllScope();

    ~symbolTable()
    {
        while(current->parent!=NULL)
        {
            current=current->parent;
        }
       delete current;
    }

};

void symbolTable::enterScope()
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

    cout<<"New ScopeTable with id "<<this->current->version<<" created"<<endl;
}

void symbolTable::exitScope()
{
    cout<<"ScopeTable with id "<<this->current->version<<" removed"<<endl;

    scopeTable* temp =(this->current->parent)->parent;
    this->current = this->current->parent;
    this->current->parent = temp;
    this->current->nextID = this->current->nextID + 1;
}
void symbolTable::insertScope(string name , string type)
{
    this->current->insertHash(name,type);
}

void symbolTable::removeScope(string name)
{
    this->current->deleteHash(name);
}

symbolInfo* symbolTable::lookupAllScope(string name )
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
    cout<<"Not found"<<endl;
}

void symbolTable::printCurrentScope()
{
    cout<<endl;
    this->current->printHash();
}

void symbolTable::printAllScope()
{
    scopeTable* temp = current;
    while(temp!=NULL)
    {
        cout<<endl;
        temp->printHash();
        temp = temp->parent ;
    }
}


int main()
{

    cout<<"### SYMBOL TABLE ###"<<endl;
    cout<<"### FAHMID AL RIFAT ###"<<endl;
    cout<<"### 1705087  ###"<<endl;
    cout<<endl;

    ifstream inFile;
    int n ;

    inFile.open("input.txt");

    if(FILE)
    {
        freopen ("output.txt","w",stdout);
    }

    if (!inFile)
    {
        cout << "\nError occurs while opening file.\n";
        return 1;
    }

    inFile>>n;

    string line;
    symbolTable st(n) ;

    while (getline(inFile, line))
    {
        cout<<endl;
        cout<<line.c_str()<<endl;
        cout<<endl;

        //vector<string> word;
        istringstream iss(line);
        string word[3];
        int i=0;

        for(string s; iss >> s; )
        {
          //word.push_back(s);
          //cout<<s<<endl;
          word[i++]=s;

        }

        if(word[0] == "I")
        {
            //cout<<word[0]<<endl;
            st.insertScope(word[1],word[2]);
            //st.printHash();
        }
        else if(word[0] == "L")
        {
            //cout<<word[0]<<endl;
            st.lookupAllScope(word[1]);
        }
        else if(word[0] == "D")
        {
            //cout<<word[0]<<endl;
            st.removeScope(word[1]);
        }
        else if(word[0] == "P")
        {
            //cout<<word[0]<<endl;
            if(word[1] == "C")
            {
              st.printCurrentScope();
            }
            else if(word[1] == "A")
            {
                st.printAllScope();
            }

        }
        else if(word[0] == "S")
        {
            //cout<<word[0]<<endl;
            st.enterScope();
        }
        else if(word[0] == "E")
        {
            //cout<<word[0]<<endl;
            st.exitScope();
        }



    }

    inFile.close();

    if(FILE)
    {
    fclose (stdout);
    }

    return 0;
}

