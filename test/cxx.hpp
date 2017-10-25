#pragma once
#include <string>
void Test_Initialize();
void Test_Terminate();
void Test_Batch();
void Test_Update();
struct Vector
{
    float x;
    float y;
    float z;
};

struct Quat
{
    float x;
    float y;
    float z;
    float w;
};

struct Transform
{
    Vector position;
    Quat quat;
    Vector scaling;
};

struct Component
{
    
};

struct Object
{
    std::string name;
	int         age;
	bool 		gender;
    Transform 	transform;
	void 		update();
	//void 		set(std::string name,int age, bool gender=false);
	void 		set(std::string name,int age, bool gender=false);
	void 		xixi(std::string name="hehe",int age=10, bool gender=false);
	void 		haha(std::string name="hehe");
	void 		hehe(int age  =10);

//    struct Component{
//        struct Component
//        {
//        };
//    };
//    struct Component
//    {
//    };
};

