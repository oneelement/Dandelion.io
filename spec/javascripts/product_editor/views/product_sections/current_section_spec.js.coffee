describe 'CurrentSection view', ->

  beforeEach ->
    @server = sinon.fakeServer.create()

    @section = new ProductEditor.Models.ProductSection()
    @view = new ProductEditor.Views.CurrentSection(model: @section)
    @view.render()

  it 'should update repeating attribute of the model', ->
    $repeatCheckbox = $('#section-attribute-repeats', @view.el)

    $repeatCheckbox.attr("checked", true)
    $repeatCheckbox.trigger("change")

    expect(@section.get("repeats")).toBeTruthy()

  it 'should update the repeating max instances of the model', ->
    $repeatCheckbox = $('#section-attribute-repeats', @view.el)

    $repeatCheckbox.attr("checked", true)
    $repeatCheckbox.trigger("change")

    $maxInstInput = $('#section-attribute-repeat-max-instances', @view.el)
    $maxInstInput.val('6')
    $maxInstInput.trigger("change")

    expect(@section.get("repeat_max_instances")).toEqual('6')
