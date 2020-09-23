<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'}
{include 'PackageDetail/index.tpl'}
{include 'PackageDetail/form.tpl'}
{include 'PackageDetail/progress.tpl'}
{include 'Partner/form.tpl'}
{include 'Target/index.tpl'}
{include 'Target/form.tpl'}

{block 'style'}
{block 'detailStyle'}{/block}
{/block}

{block name='content'}
<div class="card rounded-0">
  <div class="card-header bg-gradient-navy rounded-0">
    <h3 class="card-title text-warning">{$subtitle}</h3>
  </div>
  <!-- /.card-header -->
  <!-- form start -->
  <form id="my_form" role="form" method="POST">
    <input type="hidden" id="id" name="id" value="{$id}" />
    <div class="card-body">
      <div class="form-group row">
        <label for="pkg_fiscal_year" class="col-lg-3 col-sm-4 col-form-label">
          Tahun Anggaran
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-1 col-sm-2 col-3">
          <input
            type="text"
            class="form-control rounded-0 text-center"
            id="pkg_fiscal_year"
            name="pkg_fiscal_year"
            value="{$smarty.session.FISCAL_YEAR}"
            autocomplete="off"
            data-toggle="datetimepicker"
            data-target="#pkg_fiscal_year"
          />
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="prg_code" class="col-lg-3 col-sm-4 col-form-label">
          Program
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-8">
          <select class="custom-select rounded-0" name="prg_code" id="prg_code">
            <option value="">-- Pilih --</option>
            {section inner $program}
            <option
              value="{$program[inner].prg_code}"
              data-value="{$program[inner].prg_name}"
            >
              {$program[inner].prg_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="prg_name" class="col-lg-3 col-sm-4 col-form-label">
          Nama Program
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-9 col-sm-8">
          <input
            type="text"
            class="form-control-plaintext rounded-0 border-bottom border-top-0 border-secondary"
            id="prg_name"
            readonly
          />
        </div>
      </div>

      <div class="form-group row">
        <label for="act_code" class="col-lg-3 col-sm-4 col-form-label">
          Kegiatan
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-8">
          <select class="custom-select rounded-0" name="act_code" id="act_code">
            <option value="">-- Pilih --</option>
            {section inner $activity}
            <option
              value="{$activity[inner].act_code}"
              data-value="{$activity[inner].act_name}"
            >
              {$activity[inner].act_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="act_name" class="col-lg-3 col-sm-4 col-form-label">
          Nama Kegiatan
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-9 col-sm-8">
          <input
            type="text"
            class="form-control-plaintext rounded-0 border-bottom border-top-0 border-secondary"
            id="act_name"
            readonly
          />
        </div>
      </div>

      {block 'detailList'}{/block}
    </div>
    <!-- /.card-body -->

    <div class="card-footer">
      <!-- prettier-ignore -->
      {include 'Templates/buttons/submit.tpl'}
      {include 'Templates/buttons/back.tpl'}
    </div>
  </form>
</div>
<!-- prettier-ignore -->
{block 'detailForm'}{/block}
{block 'progressForm'}{/block}
{block 'partnerForm'}{/block}
{block 'targetList'}{/block}
{block 'targetForm'}{/block}
{/block} 

{block 'script'}
{block 'detailFormJS'}{/block}
{block 'detailJS'}{/block}
{block 'partnerScript'}{/block}
{block 'targetScript'}{/block}
{block 'targetFormScript'}{/block}
{literal}
<script>
  $(document).ready(function () {
    let id = document.querySelector('#my_form #id').value
    if (id) {
      getDetail(id)
    }

    $('#pkg_fiscal_year').datetimepicker({
      viewMode: 'years',
      format: 'YYYY',
    })

    $('#prg_code')
      .change(function () {
        if ($(this).val()) {
          $('#prg_name').val(
            $(this)
              .find(`option[value=${$(this).val()}]`)
              .data('value')
          )
        }
      })
      .change()

    $('#act_code')
      .change(function () {
        if ($(this).val()) {
          $('#act_name').val(
            $(this)
              .find(`option[value=${$(this).val()}]`)
              .data('value')
          )
        }
      })
      .change()

    $('#btn_submit').click(() => {
      clearErrorMessage()
      save()
    })
  })

  let getDetail = (data_id) => {
    $.post(
      `${MAIN_URL}/detail`,
      { id: data_id },
      function (res) {
        $.each(res, (id, value) => {
          $(`#my_form #${id}`).val(value)
        })
        $('#my_form #prg_code').change()
        $('#my_form #act_code').change()
      },
      'JSON'
    )
  }

  let save = () => {
    $.post(
      `${MAIN_URL}/submit`,
      $('#my_form').serialize(),
      (res) => {
        if (!res.success) {
          if (typeof res.msg === 'object') {
            $.each(res.msg, (id, message) => {
              showErrorMessage(id, message)
            })
          } else flash(res.msg, 'error')
        } else window.location = MAIN_URL
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
