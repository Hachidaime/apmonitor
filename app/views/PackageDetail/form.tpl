{block 'detailForm'}
<!-- Modal -->
<div
  class="modal fade"
  id="detailFormModal"
  data-backdrop="static"
  data-keyboard="false"
  tabindex="-1"
  aria-labelledby="detailFormModalLabel"
  aria-hidden="true"
>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailFormModalLabel">Modal title</h5>
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form id="detail_form" role="form" method="POST">
        <input type="hidden" id="id" name="id" value="{$id}" />
        <div class="modal-body">
          ...
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">
            Close
          </button>
          <button type="button" class="btn btn-primary">Understood</button>
        </div>
      </form>
    </div>
  </div>
</div>
{/block}
