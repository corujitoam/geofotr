Geofotr.Views.PhotoEdit = Backbone.CompositeView.extend({

  template: JST['photos/photo_edit'],

  events: {
    'click button.submit' : 'submitForm'
  },

  initialize: function () {
    this.listenTo(this.model, 'sync', this.render)
    this.listenTo(this.model, 'change', this.render)
  },

  render: function () {
    this.$el.html(this.template({
      photo: Geofotr.photoToEdit
    }));
    this.attachSubviews();
    return this;
  },

  submitForm: function () {
    event.preventDefault();
    params = this.$('form').serializeJSON();
    var that = this;

    var success = function (model) {
      that.collection.add(model, { merge: true });
      Backbone.history.navigate('', { trigger: true })
    };

    var error = function (model) {
      console.log('error')
    }

    this.model.save(params, {
      success: success,
      error: error
    });
  },

});
