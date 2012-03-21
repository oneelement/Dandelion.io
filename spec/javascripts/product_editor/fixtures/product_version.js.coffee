beforeEach ->
  if not @fixtures?
    @fixtures = {}

    @fixtures.ProductVersions = {
      nestedStructure: {
        "id": "vid",
        "product_id": "pid",
        "product_name":"test product",
        "version_description":"Initial development version",
        "live_date":null,
        "product_sections":[
          {
            "section":{
              "id":"1",
              "name":"Premises"
            },
            "product_sections":[
              {
                "section":{
                  "id":"2",
                  "name":"Contents"
                },
                "product_sections":[
                  {
                    "section":{
                      "id":"3",
                      "name":"Specified Contents Item"
                    },
                    "product_sections":[],
                    "product_questions":[]
                  }
                ],
                "product_questions":[]
              }, {
                "section":{
                  "id":"4",
                  "name":"Buildings"
                },
                "product_sections":[],
                "product_questions":[]
              }
            ],
            "product_questions":[]
          },{
            "section":{
              "id":"5",
              "name":"Employer's Liability"
            },
            "product_sections":[],
            "product_questions":[]
          }
        ]
      }
    }
