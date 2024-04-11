package handler

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"zeus_authz/internal/logic"
	"zeus_authz/internal/svc"
	"zeus_authz/internal/types"
)

func Zeus_authzHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.Request
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := logic.NewZeus_authzLogic(r.Context(), svcCtx)
		resp, err := l.Zeus_authz(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
