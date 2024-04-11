package logic

import (
	"context"
	"encoding/hex"

	"zeus_authz/internal/svc"
	"zeus_authz/internal/types"

	"github.com/google/uuid"
	"github.com/zeromicro/go-zero/core/logx"
)

type Zeus_authzLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewZeus_authzLogic(ctx context.Context, svcCtx *svc.ServiceContext) *Zeus_authzLogic {
	return &Zeus_authzLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *Zeus_authzLogic) Zeus_authz(req *types.Request) (resp *types.Response, err error) {
	// todo: add your logic here and delete this line
	bytes, _ := uuid.New().MarshalBinary()
	id := hex.EncodeToString(bytes)

	return
}
