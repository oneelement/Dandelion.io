#= require_tree ../fixtures

describe 'ProductVersion model', ->

  beforeEach ->
    @server = sinon.fakeServer.create()
    @server.respondWith("/products/pid/versions/vid",
      @validResponse(@fixtures.ProductVersions.nestedStructure))

  beforeEach ->
    @version = new ProductEditor.Models.ProductVersion(
      product_id: 'pid'
      _id: 'vid'
    )

  describe 'when fetching a nested product structure', ->

    beforeEach ->
      @version.fetch()
      @server.respond()

    it 'should build the product structure correctly', ->

      root_sections = @version.get("product_sections")

      expect(root_sections.length).toEqual(2)

      psec0 = root_sections.models[0]
      psec1 = root_sections.models[1]

      expect(psec0.get("section").get("name")).toEqual("Premises")
      expect(psec1.get("section").get("name")).toEqual("Employer's Liability")

      psec0psec0 = psec0.get("product_sections").models[0]
      psec0psec1 = psec0.get("product_sections").models[1]

      expect(psec0psec0.get("section").get("name")).toEqual("Contents")
      expect(psec0psec1.get("section").get("name")).toEqual("Buildings")

      psec0psec0psec0 = psec0psec0.get("product_sections").models[0]

      expect(psec0psec0psec0.get("section").get("name")).toEqual("Specified Contents Item")

    it 'should convert the nested product structure back to JSON correctly', ->

      json = @version.toJSON()
      fix = @fixtures.ProductVersions.nestedStructure

      expect(json).toEqual(fix)
