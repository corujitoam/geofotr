Geofotr.Collections.Comments = Backbone.Collection.extend({
  url: "/api/comments",
  model: Geofotr.Models.Comment,

  comparator: function(comment) {
    return -comment.get('created_at');
  },
});
