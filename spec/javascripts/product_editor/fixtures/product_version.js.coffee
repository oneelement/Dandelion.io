beforeEach ->
  if not @fixtures?
    @fixtures = {}

    @fixtures.ProductVersions = {
      nestedStructure: {
        "_id": "vid",
        "product_id": "pid",
        "product_name":"test product",
        "version_description":"Initial development version",
        "live_date":null,
        "product_sections":[
          {
            "section":{
              "_id":"1",
              "name":"Premises"
            },
            "product_sections":[
              {
                "section":{
                  "_id":"2",
                  "name":"Contents"
                },
                "product_sections":[
                  {
                    "section":{
                      "_id":"3",
                      "name":"Specified Contents Item"
                    },
                    "product_sections":[],
                    "product_questions":[]
                  }
                ],
                "product_questions":[]
              }, {
                "section":{
                  "_id":"4",
                  "name":"Buildings"
                },
                "product_sections":[],
                "product_questions":[]
              }
            ],
            "product_questions":[]
          },{
            "section":{
              "_id":"5",
              "name":"Employer's Liability"
            },
            "product_sections":[],
            "product_questions":[]
          }
        ]
      }
    }
